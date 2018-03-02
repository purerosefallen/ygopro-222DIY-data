--太郎丸
function c75646025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(0x20008)
	e2:SetType(0x81)
	e2:SetProperty(0x10000)
	e2:SetCode(1102)
	e2:SetTarget(c75646025.thtg)
	e2:SetCountLimit(1,75646025)
	e2:SetOperation(c75646025.thop)
	c:RegisterEffect(e2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x200000)
	e1:SetProperty(0x4000)
	e1:SetHintTiming(0x2000)
	e1:SetType(0x100)
	e1:SetCode(1002)
	e1:SetCountLimit(1)
	e1:SetRange(0x4)
	e1:SetCost(c75646025.cost)
	e1:SetOperation(c75646025.operation)
	c:RegisterEffect(e1)
end
function c75646025.thfilter(c)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsAbleToHand()
end
function c75646025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646025.thfilter,tp,0x1,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,0x1)
end
function c75646025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646025.thfilter,tp,0x1,0,1,1,nil)
	if g:GetCount()>0  then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646025.cfilter(c)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsReleasableByEffect() and not c:IsCode(75646025)
end
function c75646025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c75646025.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c75646025.cfilter,1,1,nil)
	Duel.Release(g,0x80)
end
function c75646025.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(0x1)
		e1:SetCode(102)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(0x1)
		e2:SetProperty(0x20000)
		e2:SetRange(0x4)
		e2:SetCode(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(c75646025.efilter)
		c:RegisterEffect(e2)
	end
end
function c75646025.efilter(e,te)
	return te:IsActiveType(0x6)
end