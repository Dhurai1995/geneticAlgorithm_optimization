function x = DecodeChromosome(chromosome, variableRange, numberOfVariable)

nGenes =size(chromosome,2);
nHalf = fix(nGenes/numberOfVariable);

for i=1:numberOfVariable
    x(i) =0.0;
    for j=1:nHalf
        x(i)=x(i) + chromosome(j+(nHalf*(i-1)))*2^(-j);
    end
    x(i) =-variableRange + 2*variableRange*x(i)/(1-2^(-nHalf));
end
end
