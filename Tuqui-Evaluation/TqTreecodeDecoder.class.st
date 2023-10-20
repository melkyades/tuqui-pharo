Class {
	#name : #TqTreecodeDecoder,
	#superclass : #Object,
	#instVars : [
		'method',
		'stream',
		'builder'
	],
	#classVars : [
		'BindingTypes',
		'NodeTypes'
	],
	#pools : [
		'AstBindingTypes',
		'AstNodeTypes'
	],
	#category : #'Tuqui-Evaluation-Runtime'
}

{ #category : #'class initialization' }
TqTreecodeDecoder class >> initialize [
	NodeTypes := Dictionary new.
	BindingTypes := Dictionary new.
	NodeTypes
		at: AssignmentId put: TqAssignment;
		at: BlockId put: TqBlock;
		at: CascadeId put: TqCascade;
		at: LiteralId put: TqLiteral;
		at: IdentifierId put: TqIdentifier;
		at: MessageId put: TqMessage;
		at: ReturnId put: TqReturn.
	BindingTypes
		at: NilId put: TqNilBinding;
		at: TrueId put: TqTrueBinding;
		at: FalseId put: TqFalseBinding;
		at: ArgumentId put: TqArgumentBinding;
		at: TemporaryId put: TqTemporaryBinding;
		at: SelfId put: TqSelfBinding;
		at: SuperId put: TqSuperBinding;
		at: DynamicVarId put: TqDynamicBinding
]

{ #category : #public }
TqTreecodeDecoder >> bindingTypeOf: id [
	^ BindingTypes at: id
]

{ #category : #accessing }
TqTreecodeDecoder >> builder: aRuntime [ 
	builder := aRuntime
]

{ #category : #public }
TqTreecodeDecoder >> decodeArgument [
	^ TqArgumentBinding new
		index: self nextInteger;
		environment: self nextEnvironment
]

{ #category : #public }
TqTreecodeDecoder >> decodeAssignment [
	| assignment assignees |
	assignment := TqAssignment new.
	
	assignees := self nextExpressionArray.
	assignment expression: self nextExpression.
	assignees do: [ :identifier | assignment assign: identifier ].
	^ assignment
]

{ #category : #public }
TqTreecodeDecoder >> decodeBlock [
	| expression inlined block index |
	expression := TqBlock new.
	inlined := self nextBoolean.
	inlined
		ifTrue: [ expression inlinedArgs: self nextArray ]
		ifFalse: [ index := self nextInteger.
			block := self literalAt: index.
			builder ifNotNil: [ builder blockExecutableCode: block put: expression ].
			expression
				compiledCode: block;
				index: index;
				capturedVariables: self nextArray ].
	expression statements: self nextExpressionArray.
	^ expression
]

{ #category : #public }
TqTreecodeDecoder >> decodeCascade [
	| cascade receiver messages message count |
	cascade := TqCascade new.
	receiver := self nextExpression.
	count := self nextInteger.
	messages := (1 to: count)
		collect: [ :i | 
			message := TqCascadeMessage decodeUsing: self.
			message cascade: cascade ].
	^ cascade
		receiver: receiver;
		messages: messages
]

{ #category : #public }
TqTreecodeDecoder >> decodeCascadeMessage [
	| selector arguments |
	selector := self nextSymbol.
	arguments := self nextExpressionArray.
	^ TqCascadeMessage new
		selector: selector;
		arguments: arguments
]

{ #category : #public }
TqTreecodeDecoder >> decodeDynamicVar [
	^ TqDynamicBinding new name: self nextSymbol
]

{ #category : #public }
TqTreecodeDecoder >> decodeIdentifier [
	| type binding |
	type := self bindingTypeOf: self nextInteger.
	binding := type decodeUsing: self.
	^ TqIdentifier new binding: binding
]

{ #category : #public }
TqTreecodeDecoder >> decodeLiteral [
	| index value |
	index := self nextInteger.
	value := index = 0
		ifTrue: [ self nextLiteralInteger ]
		ifFalse: [ self literalAt: index ].
	^ TqLiteral new
		index: index;
		value: value
]

{ #category : #public }
TqTreecodeDecoder >> decodeMessage [
	| inlined selector receiver arguments |
	inlined := self nextBoolean.
	selector := self nextSymbol.
	receiver := self nextExpression.
	arguments := self nextExpressionArray.
	^ TqMessage new
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		inlined: inlined
]

{ #category : #public }
TqTreecodeDecoder >> decodeMethod [
	| type node next pragma |
	type := stream next.
	type != MethodId
		ifTrue: [ self error: 'method astcode expected' ].
	node := TqMethod new.
	next := stream peek.
	next = PragmaId
		ifTrue: [ stream next.
			pragma := TqPragma new name: self nextSymbolOrNil.
			node pragma: pragma ].
	node
		compiledCode: method;
		statements: self nextExpressionArray.
	^ node
]

{ #category : #public }
TqTreecodeDecoder >> decodeReturn [
	| expression local |
	local := self nextBoolean.
	expression := self nextExpression.
	^ TqReturn new
		local: local;
		expression: expression
]

{ #category : #public }
TqTreecodeDecoder >> decodeTemporary [
	^ TqTemporaryBinding new
		index: self nextInteger;
		environment: self nextEnvironment
]

{ #category : #unclassified }
TqTreecodeDecoder >> literalAt: anInteger [
	^ builder ifNil: [method at: anInteger] ifNotNil: [builder method: method literalAt: anInteger]
]

{ #category : #accessing }
TqTreecodeDecoder >> method: aMethod [
	method := aMethod
]

{ #category : #public }
TqTreecodeDecoder >> nextArray [
	| count |
	count := self nextInteger.
	^ stream next: count
]

{ #category : #initialization }
TqTreecodeDecoder >> nextBoolean [
	^ stream next = 1
]

{ #category : #public }
TqTreecodeDecoder >> nextEnvironment [
	| value |
	value := self nextInteger.
	^ value != -2
		ifTrue: [ value ]
]

{ #category : #public }
TqTreecodeDecoder >> nextExpression [
	| type |
	type := self nodeTypeOf: stream next.
	^type decodeUsing: self.

]

{ #category : #public }
TqTreecodeDecoder >> nextExpressionArray [
	| count |
	count := self nextInteger.
	^(1 to: count) collect: [ :arg | self nextExpression ]
]

{ #category : #initialization }
TqTreecodeDecoder >> nextInteger [
	| value |
	value := stream next.
	value = 16r80
		ifTrue: [ ^ stream int64 ].
	^ value <= 127
		ifTrue: [ value ]
		ifFalse: [ value - 16r100 ]
]

{ #category : #unclassified }
TqTreecodeDecoder >> nextLiteralInteger [
	| value |
	value := self nextInteger.
	^ builder
		ifNil: [ value ]
		ifNotNil: [ builder newInteger: value ]
]

{ #category : #public }
TqTreecodeDecoder >> nextSymbol [
	| index |
	index := self nextInteger.
	^ self literalAt: index
]

{ #category : #public }
TqTreecodeDecoder >> nextSymbolOrNil [
	| index |
	index := self nextInteger.
	^index != 0 ifTrue: [ self literalAt: index]
]

{ #category : #initialization }
TqTreecodeDecoder >> nextUnsignedInteger [
	| value |
	value := self nextByte.
	^value < 128
		ifTrue: [value]
		ifFalse: [value - 128 + (self nextUnsignedInteger bitShift: 7)]
]

{ #category : #public }
TqTreecodeDecoder >> nodeTypeOf: id [
	^NodeTypes at: id
]

{ #category : #accessing }
TqTreecodeDecoder >> stream: aStream [
	stream := aStream
]
