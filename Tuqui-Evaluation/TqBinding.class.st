Class {
	#name : #TqBinding,
	#superclass : #Object,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqBinding class >> decodeUsing: anAstcodeDecoder [
	^self subclassResponsibility
]

{ #category : #testing }
TqBinding >> assign: value within: aPowertalkRuntime [
	^ self subclassResponsibility
]

{ #category : #testing }
TqBinding >> isArgument [
	^false
]

{ #category : #testing }
TqBinding >> isAssociation [
	^false
]

{ #category : #testing }
TqBinding >> isClassBinding [
	^false
]

{ #category : #testing }
TqBinding >> isClassVar [
	^false
]

{ #category : #testing }
TqBinding >> isDynamic [
	^ false
]

{ #category : #testing }
TqBinding >> isInstVar [
	^false
]

{ #category : #testing }
TqBinding >> isLiteral [
	^false
]

{ #category : #testing }
TqBinding >> isPoolVar [
	^false
]

{ #category : #testing }
TqBinding >> isSelf [
	^false
]

{ #category : #testing }
TqBinding >> isSuper [
	^false
]

{ #category : #testing }
TqBinding >> isTemporary [
	^false
]

{ #category : #testing }
TqBinding >> name [
	^self printString
]

{ #category : #testing }
TqBinding >> valueWithin: anEvaluationContext [
	^ self subclassResponsibility
]
