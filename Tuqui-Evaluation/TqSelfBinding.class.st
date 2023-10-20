Class {
	#name : #TqSelfBinding,
	#superclass : #TqBinding,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqSelfBinding class >> decodeUsing: anAstcodeDecoder [
	^self new
]

{ #category : #testing }
TqSelfBinding >> isSelf [
	^true
]

{ #category : #printing }
TqSelfBinding >> printOn: aStream [
	aStream nextPutAll: 'SelfId'
]

{ #category : #testing }
TqSelfBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext receiver
]
