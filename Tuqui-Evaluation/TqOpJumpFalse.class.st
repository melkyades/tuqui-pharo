Class {
	#name : #TqOpJumpFalse,
	#superclass : #TqOpJump,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpJumpFalse >> acceptVisitor: visitor [
	^ visitor visitOpJumpFalse: self
]
