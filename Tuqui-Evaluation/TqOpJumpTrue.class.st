Class {
	#name : #TqOpJumpTrue,
	#superclass : #TqOpJump,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpJumpTrue >> acceptVisitor: visitor [
	^ visitor visitOpJumpTrue: self
]
