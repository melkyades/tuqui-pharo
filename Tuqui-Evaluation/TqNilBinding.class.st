Class {
	#name : #TqNilBinding,
	#superclass : #TqLiteralBinding,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #evaluating }
TqNilBinding >> printOn: aStream [
	aStream nextPutAll: 'NilId'
]

{ #category : #evaluating }
TqNilBinding >> value [
	^nil
]

{ #category : #evaluating }
TqNilBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext nil
]
