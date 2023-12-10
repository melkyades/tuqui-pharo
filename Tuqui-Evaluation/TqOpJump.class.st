Class {
	#name : #TqOpJump,
	#superclass : #TqOperation,
	#instVars : [
		'target'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #accessing }
TqOpJump >> acceptVisitor: visitor [
	^ visitor visitOpJump: self
]

{ #category : #accessing }
TqOpJump >> printOn: aStream [
	aStream nextPutAll: self class name withArticle; nextPutAll: ' after '; print: target
]

{ #category : #accessing }
TqOpJump >> target [ 
	^target
]

{ #category : #accessing }
TqOpJump >> target: anInteger [
	 target := anInteger
]
