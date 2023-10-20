Class {
	#name : #TqMessage,
	#superclass : #TqExpression,
	#instVars : [
		'selector',
		'receiver',
		'arguments',
		'cache',
		'inlined'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqMessage class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeMessage
]

{ #category : #'instance creation' }
TqMessage class >> new [
	"return an initialized instance"

	^ self basicNew initialize.

]

{ #category : #printing }
TqMessage >> acceptVisitor: visitor [
	^visitor visitMessage: self
]

{ #category : #accessing }
TqMessage >> argumentCount [
	^arguments size
]

{ #category : #printing }
TqMessage >> arguments [
	^arguments
]

{ #category : #printing }
TqMessage >> arguments: aCollection [
	arguments := aCollection
]

{ #category : #printing }
TqMessage >> flushCache [
	cache := nil
]

{ #category : #printing }
TqMessage >> initialize [
	super initialize.
	arguments := #().
	inlined := false
]

{ #category : #private }
TqMessage >> inlined: aBoolean [
	inlined := aBoolean
]

{ #category : #printing }
TqMessage >> isInlined [
	^ inlined
]

{ #category : #printing }
TqMessage >> isMessage [
	^true
]

{ #category : #printing }
TqMessage >> printOn: aStream indent: anInteger [
	aStream tab: anInteger; nextPutAll: '{MessageId. '; print: selector; nextPutAll: '. '; cr.
	receiver printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '.'; cr.
	arguments
		do: [:statement | statement printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '. '; cr].
	aStream nextPutAll: '}'
]

{ #category : #printing }
TqMessage >> receiver [
	^receiver
]

{ #category : #printing }
TqMessage >> receiver: anSExpression [
	receiver := anSExpression
]

{ #category : #printing }
TqMessage >> selector [
	^selector
]

{ #category : #printing }
TqMessage >> selector: aSelector [
	selector := aSelector
]
