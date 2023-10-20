Class {
	#name : #TqLiteralBinding,
	#superclass : #TqBinding,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqLiteralBinding class >> decodeUsing: anAstcodeDecoder [
	^self new
]

{ #category : #testing }
TqLiteralBinding >> isLiteral [
	^true
]
