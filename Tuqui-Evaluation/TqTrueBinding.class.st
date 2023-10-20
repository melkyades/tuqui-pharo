Class {
	#name : #TqTrueBinding,
	#superclass : #TqLiteralBinding,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #printing }
TqTrueBinding >> printOn: aStream [
	aStream nextPutAll: 'TrueId'
]

{ #category : #printing }
TqTrueBinding >> value [
	^true
]

{ #category : #printing }
TqTrueBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext true
]
