--偶像·望月杏奈
function c81016001.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c81016001.spcon)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81016001)
	e3:SetCondition(c81016001.chcon)
	e3:SetCost(c81016001.cost)
	e3:SetTarget(c81016001.chtg)
	e3:SetOperation(c81016001.chop)
	c:RegisterEffect(e3)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c81016001.atkcon)
	e5:SetValue(3000)
	c:RegisterEffect(e5)
end
function c81016001.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81d)
end
function c81016001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c81016001.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
			and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_EXTRA,0)==0
end
function c81016001.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c81016001.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81016001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c81016001.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c81016001.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c81016001.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,rp,LOCATION_EXTRA,0,1,nil) end
end
function c81016001.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c81016001.repop)
end
function c81016001.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c81016001.atkcon(e)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
