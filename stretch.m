function out = stretch(vector,factor)
center = (vector(1) + vector(end)) / 2;
vector_shifted = vector - center;
vector_stretched = vector_shifted * factor;
out = vector_stretched + center;
end
