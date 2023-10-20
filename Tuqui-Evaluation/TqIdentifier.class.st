Class {
	#name : #TqIdentifier,
	#superclass : #TqExpression,
	#instVars : [
		'binding'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqIdentifier class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeIdentifier
]

{ #category : #visiting }
TqIdentifier >> acceptVisitor: visitor [
	^visitor visitIdentifier: self
]

{ #category : #accessing }
TqIdentifier >> binding [
	^binding
]

{ #category : #visiting }
TqIdentifier >> binding: aBinding [
	binding := aBinding
]

{ #category : #visiting }
TqIdentifier >> isArgument [
	^binding isArgument
]

{ #category : #visiting }
TqIdentifier >> isAssociation [
	^binding isAssociation
]

{ #category : #visiting }
TqIdentifier >> isIdentifier [
	^true
]

{ #category : #visiting }
TqIdentifier >> isInstVar [
	^binding isInstVar
]

{ #category : #visiting }
TqIdentifier >> isLiteral [
	^binding isLiteral
]

{ #category : #visiting }
TqIdentifier >> isSelf [
	^binding isSelf
]

{ #category : #visiting }
TqIdentifier >> isSelfOrSuper [
	^binding isSelf or: [binding isSuper]
]

{ #category : #visiting }
TqIdentifier >> isSuper [
	^binding isSuper
]

{ #category : #visiting }
TqIdentifier >> isTemporary [
	^binding isTemporary
]

{ #category : #visiting }
TqIdentifier >> isVariable [
	^true
]

{ #category : #visiting }
TqIdentifier >> printOn: aStream indent: anInteger [
	aStream
		tab: anInteger;
		nextPutAll: '{IdentifierId. ';
		print: binding;
		nextPutAll: '}'
]
