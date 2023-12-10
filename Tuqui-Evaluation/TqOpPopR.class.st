Class {
	#name : #TqOpPopR,
	#superclass : #TqOperation,
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #visiting }
TqOpPopR >> acceptVisitor: visitor [
	^ visitor visitOpPopR: self
]
