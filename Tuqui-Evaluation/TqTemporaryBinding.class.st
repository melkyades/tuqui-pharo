Class {
	#name : #TqTemporaryBinding,
	#superclass : #TqLocalBinding,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqTemporaryBinding class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeTemporary
]

{ #category : #'as yet unclassified' }
TqTemporaryBinding >> assign: value within: anEvaluationContext [
	anEvaluationContext temporaryAt: position in: environment put: value
]

{ #category : #testing }
TqTemporaryBinding >> isInCurrentEnvironment [

	^ environment = 0
]

{ #category : #testing }
TqTemporaryBinding >> isTemporary [
	^true
]

{ #category : #'as yet unclassified' }
TqTemporaryBinding >> printOn: aStream [
	aStream
		nextPutAll: 'STemporary ';
		print: position;
		nextPutAll: ' @ env ';
		print: environment
]

{ #category : #'as yet unclassified' }
TqTemporaryBinding >> valueWithin: anEvaluationContext [
	^ anEvaluationContext temporaryAt: position in: environment
]
