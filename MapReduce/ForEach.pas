var
  I: Integer;
  Done: Boolean;
  X: T;
begin
  I := 0;
  Done := False;
  for X in Source do
  begin
    Lambda(X, I, Done);
    if Done then
      Break;
	Inc(I);  
  end;
end;