Class {
	#name : #TqCascade,
	#superclass : #TqExpression,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqCascade class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeCascade
]

{ #category : #visiting }
TqCascade >> acceptVisitor: visitor [
	^visitor visitCascade: self
]

{ #category : #testing }
TqCascade >> isCascade [
	^true
]

{ #category : #accessing }
TqCascade >> messages [
	^messages
]

{ #category : #accessing }
TqCascade >> messages: aCollection [
	messages := aCollection
]

{ #category : #accessing }
TqCascade >> receiver [
	^receiver
]

{ #category : #accessing }
TqCascade >> receiver: anSExpression [
	receiver := anSExpression
]
