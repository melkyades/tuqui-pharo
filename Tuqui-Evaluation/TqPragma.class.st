Class {
	#name : #TqPragma,
	#superclass : #TqExpression,
	#instVars : [
		'name'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #accessing }
TqPragma >> name [
	^ name
]

{ #category : #accessing }
TqPragma >> name: aString [
	name := aString
]
