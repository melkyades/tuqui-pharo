Class {
	#name : #TqReturn,
	#superclass : #TqExpression,
	#instVars : [
		'local',
		'expression'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqReturn class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeReturn
]

{ #category : #visiting }
TqReturn >> acceptVisitor: visitor [
	^visitor visitReturn: self
]

{ #category : #visiting }
TqReturn >> expression [
	^expression
]

{ #category : #visiting }
TqReturn >> expression: anSExpression [
	expression := anSExpression
]

{ #category : #visiting }
TqReturn >> isReturn [
	^true
]

{ #category : #visiting }
TqReturn >> local [
	^local
]

{ #category : #visiting }
TqReturn >> local: aBoolean [
	local := aBoolean
]

{ #category : #visiting }
TqReturn >> printOn: aStream indent: anInteger [
	aStream tab: anInteger; nextPutAll: '{ReturnId.'; cr.
	expression printOn: aStream indent: anInteger + 1.
	aStream nextPutAll: '}'
]
