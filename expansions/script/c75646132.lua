--气虚之灵
function c75646132.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x2)
	e1:SetCode(34)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(0x2)
	e1:SetTargetRange(0x5,1)
	e1:SetCondition(c75646132.spcon)
	e1:SetOperation(c75646132.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(0x1+0x200)
	e2:SetProperty(0x800)
	e2:SetCode(1102)
	e2:SetTarget(c75646132.target)
	e2:SetOperation(c75646132.operation)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(0x2)
	e3:SetCode(85)
	e3:SetRange(0x4)
	e3:SetTargetRange(0x4,0x4)
	e3:SetTarget(c75646132.atktarget)
	c:RegisterEffect(e3)
end
function c75646132.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,0x4)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0x2,0,1,c)
end
function c75646132.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(3,tp,501)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0x2,0,1,1,c)
	Duel.SendtoGrave(g,0x80+REASON_DISCARD)
end
function c75646132.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c75646132.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x1)
	e1:SetProperty(0x800)
	e1:SetCode(6)
	e1:SetTargetRange(1,1)
	e1:SetValue(c75646132.aclimit)
	e1:SetReset(RESET_PHASE+0x200)
	Duel.RegisterEffect(e1,tp)
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:GetAttack()==0 then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(0x1)
	e2:SetCode(101)
	e2:SetValue(0)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c75646132.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==0x10 and re:IsActiveType(0x1)
end
function c75646132.atktarget(e,c)
	return c:GetBaseAttack()>=2500 and c~=e:GetHandler()
end
