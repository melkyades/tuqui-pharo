Class {
	#name : #BytecodeGenerator,
	#superclass : #Object,
	#instVars : [
		'operations',
		'primitives',
		'inBlock',
		'runtime',
		'greaterThan',
		'one',
		'plus',
		'stackTop',
		'dropsArguments',
		'not',
		'equalsEquals',
		'ifTrue',
		'ifFalse',
		'ifTrueIfFalse',
		'ifFalseIfTrue',
		'ifNil',
		'ifNotNil',
		'ifNilIfNotNil',
		'ifNotNilIfNil',
		'whileTrue',
		'whileFalse',
		'whileTrue_',
		'whileFalse_',
		'toDo',
		'toByDo',
		'repeat',
		'timesRepeat',
		'andNot',
		'orNot'
	],
	#category : #'Tuqui-Evaluation'
}

{ #category : #initialization }
BytecodeGenerator >> assign: aCollection [
	| op |
	op := TqOpAssign new assignees: aCollection.
	operations add: op

]

{ #category : #initialization }
BytecodeGenerator >> branchIf: aBoolean [
	| class op |
	class := aBoolean
		ifTrue: [ TqOpJumpTrue ]
		ifFalse: [ TqOpJumpFalse ].
		op := class new.
	operations add: op.
	^op
]

{ #category : #initialization }
BytecodeGenerator >> branchTargetOf: branch [
	branch target: self currentPC
]

{ #category : #initialization }
BytecodeGenerator >> currentPC [
	^ operations size
]

{ #category : #initialization }
BytecodeGenerator >> dispatch: message [
	| op count |
	op := TqOpDispatchMessage new message: message.
	operations add: op.
	dropsArguments ifTrue: [ ^self ].
	
	count := message arguments size.
	count > 0 ifTrue: [ count := count + 1 ].
	stackTop := stackTop - count 
]

{ #category : #initialization }
BytecodeGenerator >> dropCascadeMessageArgs: argsize [
	(argsize = 0 orNot: [ dropsArguments ])
		ifTrue: [ ^ self ].
	self dropToS: argsize
]

{ #category : #initialization }
BytecodeGenerator >> dropMessageArgs: argsize [
	(argsize = 0 orNot: [ dropsArguments ])
		ifTrue: [ ^ self ].
	self dropToS: argsize + 1
]

{ #category : #initialization }
BytecodeGenerator >> dropToS [
	^self dropToS: 1
]

{ #category : #initialization }
BytecodeGenerator >> dropToS: anInteger [
	| op |
	op := TqOpDropToS new count: anInteger.
	operations add: op.
	stackTop := stackTop - anInteger
]

{ #category : #initialization }
BytecodeGenerator >> dropsArguments [
	dropsArguments := true
]

{ #category : #initialization }
BytecodeGenerator >> initialize [
	dropsArguments := false
]

{ #category : #initialization }
BytecodeGenerator >> jump [
	| op |
	op := TqOpJump new.
	operations add: op.
	^op
]

{ #category : #initialization }
BytecodeGenerator >> jumpTo: anInteger [
| op |
op := TqOpJump new target: anInteger.
	operations add: op
]

{ #category : #initialization }
BytecodeGenerator >> loadRfromStack: anInteger [
	| op |
	op := TqOpLoadRfromStack new index: anInteger.
	operations add: op

]

{ #category : #initialization }
BytecodeGenerator >> loadRwithNil [
	operations add: TqOpLoadRwithNil new
]

{ #category : #initialization }
BytecodeGenerator >> loadRwithSelf [
	operations add: TqOpLoadRwithSelf new
]

{ #category : #initialization }
BytecodeGenerator >> operations [
^operations
]

{ #category : #initialization }
BytecodeGenerator >> popR [
	operations add: TqOpPopR new.
	stackTop := stackTop - 1
]

{ #category : #initialization }
BytecodeGenerator >> primitive: aClosure [
	operations add: (TqOpPrimitive new block: aClosure)
]

{ #category : #accessing }
BytecodeGenerator >> primitives: aCollection [ 
	primitives := aCollection
]

{ #category : #initialization }
BytecodeGenerator >> pushR [
	operations add: TqOpPushR new.
	stackTop := stackTop + 1
]

{ #category : #initialization }
BytecodeGenerator >> reset [
	operations := OrderedCollection new.
	inBlock := false.

]

{ #category : #initialization }
BytecodeGenerator >> return [
	operations add: TqOpReturn new
]

{ #category : #initialization }
BytecodeGenerator >> return: isLocal [
	|  class |
	class := (isLocal andNot: [ inBlock ])
		ifTrue: [ TqOpReturn ]
		ifFalse: [ TqOpNonLocalReturn ].
	operations add: class new
]

{ #category : #initialization }
BytecodeGenerator >> runtime: aPowertalkRuntime [
	| literal |
	runtime := aPowertalkRuntime.
	literal := runtime newInteger: 1.
	one := SLiteral new value: literal.
	plus := runtime symbolFromLocal: #+.
	greaterThan := runtime symbolFromLocal: #>.
	equalsEquals := runtime symbolFromLocal: #==.
	not := runtime symbolFromLocal: #not.
	ifTrue := runtime symbolFromLocal: #ifTrue:.
	ifFalse := runtime symbolFromLocal: #ifFalse:.
	ifTrueIfFalse := runtime symbolFromLocal: #ifTrue:ifFalse:.
	ifFalseIfTrue := runtime symbolFromLocal: #ifFalse:ifTrue:.
	ifNil := runtime symbolFromLocal: #ifNil:.
	ifNotNil := runtime symbolFromLocal: #ifNotNil:.
	ifNilIfNotNil := runtime symbolFromLocal: #ifNil:ifNotNil:.
	ifNotNilIfNil := runtime symbolFromLocal: #ifNotNil:ifNil:.
	repeat := runtime symbolFromLocal: #repeat.
	whileTrue := runtime symbolFromLocal: #whileTrue.
	whileFalse := runtime symbolFromLocal: #whileFalse.
	whileTrue_ := runtime symbolFromLocal: #whileTrue:.
	whileFalse_ := runtime symbolFromLocal: #whileFalse:.
	timesRepeat := runtime symbolFromLocal: #timesRepeat:.
	toDo := runtime symbolFromLocal: #to:do:.
	toByDo := runtime symbolFromLocal: #to:by:do:.
	andNot := runtime symbolFromLocal: #andNot:.
	orNot := runtime symbolFromLocal: #orNot:
]

{ #category : #initialization }
BytecodeGenerator >> visitMethod: anSMethod [

	|  primitive statements  |
	self reset.
	anSMethod pragma
	ifNotNil: [
		primitive := primitives at: anSMethod primitive.
		^ self
			  primitive: primitive;
			  return ].
	stackTop := runtime methodTempCount: anSMethod compiledCode.
	statements := anSMethod statements.
	statements do: [ :node | node acceptVisitor: self ].
	(statements isEmpty orNot: [ statements last isReturn ]) ifTrue: [
		self
			loadRwithSelf;
			return ]
]
