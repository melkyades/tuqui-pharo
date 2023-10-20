Class {
	#name : #TqBlock,
	#superclass : #TqScript,
	#instVars : [
		'index',
		'capturedVariables',
		'inlinedArgs'
	],
	#category : #'Tuqui-Evaluation-SExpressions'
}

{ #category : #unclassified }
TqBlock class >> decodeUsing: anAstcodeDecoder [
	^anAstcodeDecoder decodeBlock
]

{ #category : #visiting }
TqBlock >> acceptVisitor: visitor [
	^visitor visitBlock: self
]

{ #category : #accessing }
TqBlock >> capturedVariables [
	^capturedVariables
]

{ #category : #accessing }
TqBlock >> capturedVariables: aCollection [
	capturedVariables := aCollection
]

{ #category : #accessing }
TqBlock >> capturesHome [
	^compiledCode capturesHome
]

{ #category : #accessing }
TqBlock >> index [
	^index
]

{ #category : #accessing }
TqBlock >> index: anInteger [
	index := anInteger
]

{ #category : #initialization }
TqBlock >> initialize [
	capturedVariables := #()
]

{ #category : #accessing }
TqBlock >> inlinedArgs [
	^ inlinedArgs
]

{ #category : #accessing }
TqBlock >> inlinedArgs: anArray [
	inlinedArgs:= anArray 
]

{ #category : #initialization }
TqBlock >> isBlock [
	^true
]

{ #category : #initialization }
TqBlock >> isInlined [
	^ compiledCode isNil
]

{ #category : #accessing }
TqBlock >> offsetOfCurrentEnvironment [
	^ 2
]

{ #category : #accessing }
TqBlock >> optimizedCode [
	^compiledCode optimizedCode
]

{ #category : #unclassified }
TqBlock >> printOn: aStream indent: anInteger [
	aStream
		tab: anInteger;
		nextPutAll: '{BlockId. capturedVariables: ';
		print: capturedVariables;
		cr.
	super printOn: aStream indent: anInteger.
	aStream nextPutAll: '}'
]
