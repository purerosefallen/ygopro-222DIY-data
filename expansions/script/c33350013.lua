--传说之魂 伪魂
function c33350013.initial_effect(c)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_OVERLAY)
	e2:SetValue(33350002)
	c:RegisterEffect(e2) 
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c33350013.atkval)
	c:RegisterEffect(e1)   
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c33350013.atkcon)
	e3:SetOperation(c33350013.atkop)
	c:RegisterEffect(e3) 
end
c33350013.setname="TaleSouls"
function c33350013.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_XYZ or r==REASON_LINK or r==REASON_FUSION 
end
function c33350013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c33350013.atkval2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function c33350013.atkval2(e,c)
	return Duel.GetMatchingGroup(c33350013.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*300
end
function c33350013.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c.setname=="TaleSouls"
end
function c33350013.atkval(e,c)
	return Duel.GetMatchingGroup(c33350013.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*500
end