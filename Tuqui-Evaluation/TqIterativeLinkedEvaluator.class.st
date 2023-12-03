Class {
	#name : #TqIterativeLinkedEvaluator,
	#superclass : #TqIterativeEvaluator,
	#instVars : [
		'bytecodeGenerator',
		'valueSymbol'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #accessing }
TqIterativeLinkedEvaluator >> evaluate [

	| operation |
	[ context notNil ] whileTrue: [
		operation := context nextOperation.
		operation acceptVisitor: self ].
	Transcript
		print: 'MessageCount: ' , messageCount asString;
		cr.
	^ regR
]

{ #category : #private }
TqIterativeLinkedEvaluator >> evaluateClosure: receiver whileFalse: arg [

	self evaluateWhile: false
]

{ #category : #private }
TqIterativeLinkedEvaluator >> evaluateClosure: receiver whileTrue: arg [
self evaluateWhile:true
]

{ #category : #private }
TqIterativeLinkedEvaluator >> evaluateClosure: closure withArgs: arguments [

	| block bytecodes receiver |
	block := runtime closureBlock: closure.
	bytecodes := runtime blockExecutableCode: block.
	receiver := (runtime blockCapturesSelf: block)
		            ifTrue: [ closure at: 1 ]
		            ifFalse: [ nilObj ].
	context := TqIterativeLinkedContext new
		           runtime: runtime;
		           beBlock;
		           parent: context;
		           self: receiver;
		           initializeForBlock: block
		           args: arguments
		           closure: closure;
							bytecodes: bytecodes.
	^ regR
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> evaluateSend: symbol to: receiver with: args [
	| literal dummy message dispatch |
	literal := SLiteral new value: nilObj.
	dummy := Array new: args size withAll: literal.
	message := SMessage new
		           selector: symbol;
		           receiver: literal;
		           arguments: dummy.
	dispatch := SOpDispatchMessage new message: message.
	regR := receiver.
	context := self evaluationContextClass new runtime: self.
	self prepareDispatch: dispatch.
	dummy isEmpty ifFalse: [ context pushOperand: receiver ].
	args do: [ :arg | context pushOperand: arg ].
	self evaluate.
	^ regR
]

{ #category : #private }
TqIterativeLinkedEvaluator >> evaluateWhile: aBoolean [

	| value branchClass argument bytecodes |
	value := SMessage new
		         selector: valueSymbol;
		         receiver: SBlock new.
	branchClass := aBoolean ifTrue: [ SOpJumpFalse ] ifFalse: [ SOpJumpTrue ].
	argument := SArgumentBinding new index: 1.
	bytecodes := {
		             SOpLoadRwithSelf new.
		             (SOpDispatchMessage new message: value).
		             (branchClass new target: 7).
		             (SIdentifier new binding: argument).
		             (SOpDispatchMessage new message: value).
		             SOpRestart new.
		             SOpReturn new }.
	context
		bytecodes: bytecodes;
		restart
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> evaluationContextClass [

	^ TqIterativeLinkedContext
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> hasFinished [
	^ context isNil
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> prepareDispatch: dispatch [

	context bytecodes: { dispatch. SOpReturn new }
]

{ #category : #private }
TqIterativeLinkedEvaluator >> prepareForExecution: method [

	| bytecodes treecodes decoder sexpressions |
	bytecodes := runtime methodExecutableCode: method.
	bytecodes == nilObj ifFalse: [ ^ bytecodes ].
	treecodes := runtime methodTreecodes: method.
	decoder := TqTreecodeDecoder new
		           stream: treecodes bytes readStream;
		           method: method;
		           builder: runtime.
	sexpressions := decoder decodeMethod.
	bytecodeGenerator visitMethod: sexpressions.
	bytecodes := bytecodeGenerator operations asArray.
	runtime methodExecutableCode: method put: bytecodes.
	^ bytecodes
]

{ #category : #initializing }
TqIterativeLinkedEvaluator >> runtime: aTqRuntime [

	super runtime: aTqRuntime.
	valueSymbol := runtime symbolFromLocal: #value.
	bytecodeGenerator := BytecodeGenerator new
		                     runtime: runtime;
		                     primitives: primitives
]

{ #category : #initializing }
TqIterativeLinkedEvaluator >> underprimitiveRestart [
	^ [ :receiver :arguments | 
	| sexpressions |
	sexpressions := runtime sexpressionsOf: context method.
	context
		restart;
		pushOperation: sexpressions ]
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpDispatchMessage: anSOpDispatchMessage [

	| message argcount arguments behavior method size environment bytecodes |
	message := anSOpDispatchMessage message.
	argcount := message argumentCount.
	arguments := context popOperands: argcount.
	(argcount > 0 andNot: [ message isCascadeMessage ]) ifTrue: [
		context popOperand ].
	message cachedUndermessage ifNotNil: [ :block |
		^ regR := block value: regR value: arguments ].
	behavior := message receiver isSuper
		            ifTrue: [ runtime superBehaviorOf: context classBinding ]
		            ifFalse: [ runtime behaviorOf: regR ].
	method := self
		          lookup: message selector
		          startingAt: behavior
		          sendSite: message.
	method isBlock ifTrue: [
		^ regR := method value: regR value: arguments ].
	size := runtime methodEnvironmentSize: method.
	environment := runtime newEnvironmentSized: size.
	bytecodes := self prepareForExecution: method.
		context := self evaluationContextClass new
		           self: regR;
		           arguments: arguments;
		           environment: environment;
		           runtime: runtime;
		           method: method;
		bytecodes: bytecodes;
		           parent: context.

]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpJumpFalse: anSOpJumpFalse [

	regR == falseObj ifTrue: [ context pc: anSOpJumpFalse target ]
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpJumpTrue: anSOpJumpTrue [

	regR == trueObj ifTrue: [ context pc: anSOpJumpTrue target ]
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpNonLocalReturn: anSOpReturn [
	context := context homeContext parent
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpPopR: anSOpPopR [

	regR := context pop
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpPrimitive: anSOpPrimtive [

	regR := anSOpPrimtive block value
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpRestart: anSOpRestart [

	context restart
]

{ #category : #accessing }
TqIterativeLinkedEvaluator >> visitOpReturn: anSOpReturn [
	context := context parent
]
