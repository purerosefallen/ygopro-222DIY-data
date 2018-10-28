--创造之匙
function c75646600.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c75646600.condition)
	e1:SetTarget(c75646600.target)
	e1:SetOperation(c75646600.activate)
	c:RegisterEffect(e1)
end
c75646600.card_code_list={75646600}
function c75646600.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=3000
end
function c75646600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c75646600.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(c75646600.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c75646600.intg)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,tp)
	Duel.RegisterFlagEffect(tp,75646600,0,0,1)
end
function c75646600.intg(e,c)
	return c:IsSetCard(0x2c5)
end
function c75646600.effectfilter(e,ct)
	local p=e:GetOwner():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and aux.IsCodeListed(te:GetHandler(),75646600)
end