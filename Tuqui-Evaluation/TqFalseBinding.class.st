Class {
	#name : #TqFalseBinding,
	#superclass : #TqLiteralBinding,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #printing }
TqFalseBinding >> printOn: aStream [
	aStream nextPutAll: 'FalseId'
]

{ #category : #printing }
TqFalseBinding >> value [
	^false
]

{ #category : #printing }
TqFalseBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext false
]
