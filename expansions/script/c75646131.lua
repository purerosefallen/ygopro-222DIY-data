--紫夜流星
function c75646131.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(0x10)
	e1:SetCode(1002)
	e1:SetProperty(0x10)
	e1:SetTarget(c75646131.target)
	e1:SetOperation(c75646131.operation)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x4)
	e2:SetCode(193)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(0x400)
	e3:SetType(0x1)
	e3:SetCode(76)
	e3:SetValue(c75646131.eqlimit)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(0x4)
	e4:SetCode(203)
	c:RegisterEffect(e4)
end
function c75646131.eqlimit(e,c)
	return c:GetLevel()==4 and c:IsAttackBelow(2000)
end
function c75646131.filter(c)
	return c:IsFaceup() and c:GetLevel()==4 and c:IsAttackBelow(2000)
end
function c75646131.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x4) and c75646131.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646131.filter,tp,0x4,0x4,1,nil) end
	Duel.Hint(3,tp,518)
	Duel.SelectTarget(tp,c75646131.filter,tp,0x4,0x4,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c75646131.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end