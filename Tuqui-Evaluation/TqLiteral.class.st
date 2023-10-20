Class {
	#name : #TqLiteral,
	#superclass : #TqLiteralVar,
	#instVars : [
		'value'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #initialization }
TqLiteral class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeLiteral
]

{ #category : #visiting }
TqLiteral >> acceptVisitor: visitor [
	^ visitor visitLiteral: self
]

{ #category : #visiting }
TqLiteral >> isLiteral [
	^true
]

{ #category : #testing }
TqLiteral >> printOn: aStream indent: anInteger [
	aStream
		tab: anInteger;
		nextPutAll: '{LiteralId. ';
		print: value;
		nextPutAll: '}'
]

{ #category : #visiting }
TqLiteral >> value [
	^value
]

{ #category : #visiting }
TqLiteral >> value: anObject [
	value := anObject
]
