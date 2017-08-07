software 'foo', depends: ['bar'] do
end

software 'bar', depends: ['foo'] do
end

firmware 'test', imports: ['foo'] do
end
