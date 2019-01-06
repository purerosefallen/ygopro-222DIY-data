--独猎蜘蛛
function c65080048.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,65080048)
	e1:SetCondition(c65080048.spcon)
	e1:SetOperation(c65080048.spop)
	c:RegisterEffect(e1)
	--Atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c65080048.trcon)
	e2:SetTarget(c65080048.trtg)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c65080048.trcon)
	e3:SetTarget(c65080048.trtg)
	c:RegisterEffect(e3)
end
function c65080048.confil(c)
	return not (c:IsFaceup() and c:IsRace(RACE_INSECT))
end
function c65080048.trcon(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local gr=g:Filter(c65080048.confil,nil)
	return g:GetCount()>0 and gr:GetCount()==0
end
function c65080048.trtg(e,c)
	return c:IsAttackPos()
end

function c65080048.spfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsPosition(POS_FACEUP_DEFENSE) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c65080048.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c65080048.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c65080048.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65080048.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end