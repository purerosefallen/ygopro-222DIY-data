--自拟态
function c69696914.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c69696914.ffilter,3,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c69696914.sucop)
	c:RegisterEffect(e2)
end
function c69696914.ffilter(c,fc,sub,mg,sg)
	return (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) 
end
function c69696914.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=c:GetMaterial()
	local g2=c:GetMaterialCount()
	local atk=g1:GetSum(Card.GetAttack)
	local fatk=atk/g2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(fatk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	local tc=g1:GetFirst()
	local code=0
	while tc do 
		code=tc:GetCode() 
		if tc:IsType(TYPE_EFFECT) then
			c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
		end
		tc=g1:GetNext()
	end
end