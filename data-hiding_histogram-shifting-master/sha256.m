function outputArg1=sha256(block)
%SHA256 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
string = reshape(block,[1,size(block,1)*size(block,2)]);
sha256hasher = System.Security.Cryptography.SHA256Managed;
sha256 = uint8(sha256hasher.ComputeHash(uint8(string))); %consider the string as 8-bit characters
%display as hex:
%abc = dec2hex(sha256)

outputArg1 = sha256;
end

