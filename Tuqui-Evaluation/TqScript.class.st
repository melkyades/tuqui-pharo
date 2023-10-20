Class {
	#name : #TqScript,
	#superclass : #TqExpression,
	#instVars : [
		'statements',
		'compiledCode'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #printing }
TqScript >> argumentCount [
	^compiledCode argumentCount
]

{ #category : #printing }
TqScript >> compiledCode [
	^compiledCode
]

{ #category : #printing }
TqScript >> compiledCode: anObject [
	compiledCode := anObject
]

{ #category : #printing }
TqScript >> initialize [
	statements := #()
]

{ #category : #accessing }
TqScript >> optimizedCode: anObject [
	^ self compiledCode optimizedCode: anObject
]

{ #category : #printing }
TqScript >> printOn: aStream indent: anInteger [
	statements
		do: [:statement | statement printOn: aStream indent: anInteger + 1]
		separatedBy: [aStream nextPutAll: '.'; cr]
]

{ #category : #printing }
TqScript >> statements [
	^statements
]

{ #category : #printing }
TqScript >> statements: aCollection [
	statements := aCollection
]

{ #category : #printing }
TqScript >> tempCount [
	^compiledCode tempCount
]
