--Dear Brave 鹿乃
function c75646400.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646400,0))
	e1:SetCategory(0x40001)
	e1:SetType(0x40)
	e1:SetProperty(0x10)
	e1:SetCode(1002)
	e1:SetCountLimit(1,75646400)
	e1:SetRange(0x4)
	e1:SetCost(c75646400.cost)
	e1:SetTarget(c75646400.tg)
	e1:SetOperation(c75646400.op)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646400,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(0x100)
	e3:SetCode(1002)
	e3:SetRange(0x4)
	e3:SetCountLimit(1,75646400)
	e3:SetCost(c75646400.atkcost)
	e3:SetOperation(c75646400.atkop)
	c:RegisterEffect(e3)
end
function c75646400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,0x80) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,0x80)
end
function c75646400.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,0xc,1,e:GetHandler()) end
	Duel.Hint(3,tp,502)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,0xc,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,0x1,g,1,0,0)
end
function c75646400.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,0x40)~=0 then
	end
	local dg=Duel.GetMatchingGroup(Card.IsType,tp,0x10,0,nil,0x1)
	if dg:GetCount()>0 and c:IsFaceup() and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,0x8)>0 and Duel.SelectYesNo(tp,aux.Stringid(75646400,2)) then
		Duel.BreakEffect()
		Duel.Hint(3,tp,518)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0x10,0,1,1,nil,0x1)
		local tc=g:GetFirst()
		if tc and not tc:IsHasEffect(291) then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(0x2000+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(0x1)
		e1:SetCode(76)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c75646400.eqlimit)
		tc:RegisterEffect(e1)
	end
	end
end
function c75646400.eqlimit(e,c)
	return e:GetOwner()==c
end
function c75646400.tgfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:GetBaseAttack()>=0
end
function c75646400.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(c75646400.tgfilter,1,nil,tp) end
	Duel.Hint(3,tp,504)
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c75646400.tgfilter,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetBaseAttack())
	Duel.SendtoGrave(g,0x80)
end
function c75646400.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(0x1)
		e1:SetCode(100)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end