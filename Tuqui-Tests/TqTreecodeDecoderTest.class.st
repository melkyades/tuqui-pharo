Class {
	#name : #TqTreecodeDecoderTest,
	#superclass : #TestCase,
	#instVars : [
		'method',
		'sexpression'
	],
	#pools : [
		'AstBindingTypes',
		'AstNodeTypes',
		'ClosureElementTypes'
	],
	#category : #'Tuqui-Tests'
}

{ #category : #compiling }
TqTreecodeDecoderTest >> compile: aString [

	^ self compile: aString in: UndefinedObject
]

{ #category : #compiling }
TqTreecodeDecoderTest >> compile: aString in: aSpecies [

	| decoder |
	method :=  SCompiler compile: aString in: aSpecies.
	decoder := TqTreecodeDecoder new
		stream: method astcodes readStream;
		method: method.
	sexpression := decoder decodeMethod
]

{ #category : #tests }
TqTreecodeDecoderTest >> test010returnSelf [

	|  statements return expression |
	self compile: 'foo ^self'.
	self assert: sexpression isMethod.
	statements := sexpression statements.
	self assert: statements size equals: 1.
	return := statements first.
	self assert: return isReturn.
	expression := return expression.
	self
		assert: expression isIdentifier;
		assert: expression binding isSelf
]

{ #category : #tests }
TqTreecodeDecoderTest >> test020returnTemp [

	| statements return expression binding |
	self compile: 'foo | t | ^t'.
	self assert: method tempCount equals: 1.
	statements := sexpression statements.
	self assert: statements size equals: 1.
	return := statements first.
	self assert: return isReturn.
	expression := return expression.
	self
		assert: expression isIdentifier.
	binding := expression binding.
	self 	assert: binding isTemporary;
		assert: binding isInStack; assert: binding index equals: 1.
]

{ #category : #tests }
TqTreecodeDecoderTest >> test021returnArg [

	| statements return expression binding |
	self compile: 'foo: arg ^arg'.
	self assert: method argumentCount equals: 1.
	statements := sexpression statements.
	self assert: statements size equals: 1.
	return := statements first.
	self assert: return isReturn.
	expression := return expression.
	self assert: expression isIdentifier.
	binding := expression binding.
	self
		assert: binding isArgument;
		assert: binding isInStack;
		assert: binding index equals: 1
]

{ #category : #tests }
TqTreecodeDecoderTest >> test50returnTempFromBlock [

	| statements temp block return expression binding |
	self compile: 'foo | t | t. [^t]'.
	self
		assert: method tempCount equals: 0;
		assert: method environmentCount equals: 1.
	statements := sexpression statements.
	temp := statements first.
	binding := temp binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding isInCurrentEnvironment;
		assert: binding index equals: 1.
	block := statements second.
	self
		assert: block isBlock;
		assert: block compiledCode environmentCount equals: 1.
	return := block statements first.
	self assert: return isReturn.
	expression := return expression.
	self assert: expression isIdentifier.
	binding := expression binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding environment equals: 1;
		assert: binding index equals: 1
]

{ #category : #tests }
TqTreecodeDecoderTest >> test51returnTempFromBlockWithSelf [

	| statements block return expression binding |
	self compile: 'foo | t | [self. ^t]'.
	self
		assert: method tempCount equals: 0;
		assert: method environmentCount equals: 1.
	statements := sexpression statements.
	self assert: statements size equals: 1.
	block := statements first.
	self assert: block isBlock; assert: block compiledCode environmentCount equals: 2.
	return := block statements second.
	self assert: return isReturn.
	expression := return expression.
	self assert: expression isIdentifier.
	binding := expression binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding environment equals: 2;
		assert: binding index equals: 1
]

{ #category : #tests }
TqTreecodeDecoderTest >> test55returnTempFromDoubleBlock [

	| statements temp block captured return expression binding |
	self compile: 'foo | t | t. [ t. [^t]]'.
	self
		assert: method tempCount equals: 0;
		assert: method environmentCount equals: 1.
	statements := sexpression statements.
	temp := statements first.
	binding := temp binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding isInCurrentEnvironment;
		assert: binding index equals: 1.
	block := statements second.
	captured := block capturedVariables.
	self
		assert: block compiledCode environmentCount equals: 1;
		assert: captured first equals: Environment;
		assert: captured size equals: 1.
	temp := block statements first.
	binding := temp binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding environment equals: 1;
		assert: binding index equals: 1.
	block := block statements second.
	captured := block capturedVariables.
	self
		assert: block compiledCode environmentCount equals: 1;
		assert: captured first equals: EnvironmentValue;
		assert: captured second equals: 1;
		assert: captured size equals: 2.

	return := block statements first.
	self assert: return isReturn.
	expression := return expression.
	self assert: expression isIdentifier.
	binding := expression binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding environment equals: 1;
		assert: binding index equals: 1
]

{ #category : #tests }
TqTreecodeDecoderTest >> test56returnTempFromDoubleBlockWithSelf [

	| statements temp block captured return expression binding |
	self compile: 'foo | t | t. [ self. t. [^t]]'.
	self
		assert: method tempCount equals: 0;
		assert: method environmentCount equals: 1.
	statements := sexpression statements.
	temp := statements first.
	binding := temp binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding isInCurrentEnvironment;
		assert: binding index equals: 1.
	block := statements second.
	captured := block capturedVariables.
	self
		assert: block compiledCode environmentCount equals: 2;
		assert: captured first equals: Self;
		assert: captured second equals: Environment;
		assert: captured size equals: 2.
	temp := block statements second.
	binding := temp binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding environment equals: 2;
		assert: binding index equals: 1.
	block := block statements third.
	captured := block capturedVariables.
	self
		assert: block compiledCode environmentCount equals: 1;
		assert: captured first equals: EnvironmentValue;
		assert: captured second equals: 2;
		assert: captured size equals: 2.

	return := block statements first.
	self assert: return isReturn.
	expression := return expression.
	self assert: expression isIdentifier.
	binding := expression binding.
	self
		assert: binding isTemporary;
		deny: binding isInStack;
		assert: binding environment equals: 1;
		assert: binding index equals: 1
]
