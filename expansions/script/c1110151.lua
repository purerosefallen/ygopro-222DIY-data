--灵都·涅槃朝霭的传说
local m=1110151
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110151.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c1110151.val2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c1110151.con3)
	e3:SetTarget(c1110151.tg3)
	e3:SetOperation(c1110151.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1110151,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c1110151.con4)
	e4:SetTarget(c1110151.tg4)
	e4:SetOperation(c1110151.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c1110151.cost5)
	e5:SetOperation(c1110151.op5)
	c:RegisterEffect(e5)
--
	if c1110151.checklp==nil then
		c1110151.checklp=true
		c1110151.lplist={[0]=Duel.GetLP(tp),[1]=Duel.GetLP(tp),}
	end
--
end
--
function c1110151.val2(e,se,sp,st)
	local sc=se:GetHandler()
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and sc:IsCode(1111301)
end
--
function c1110151.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_RITUAL)~=0
end
--
function c1110151.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
--
function c1110151.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetLP(tp,c1110151.lplist[tp])
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if sg:GetCount()<1 then return end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
--
function c1110151.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsChainNegatable(ev) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
--
function c1110151.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
--
function c1110151.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler():IsRelateToEffect(re) then return end
	if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)<1 then return end
	if re:IsActiveType(TYPE_MONSTER) then
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e4_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4_1:SetRange(LOCATION_MZONE)
		e4_1:SetValue(c1110151.efilter4_1)
		e4_1:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4_1)
	end
	if re:IsActiveType(TYPE_SPELL) then
		local e4_2=Effect.CreateEffect(c)
		e4_2:SetType(EFFECT_TYPE_SINGLE)
		e4_2:SetCode(EFFECT_IMMUNE_EFFECT)
		e4_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4_2:SetRange(LOCATION_MZONE)
		e4_2:SetValue(c1110151.efilter4_2)
		e4_2:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4_2)
	end
	if re:IsActiveType(TYPE_TRAP) then
		local e4_3=Effect.CreateEffect(c)
		e4_3:SetType(EFFECT_TYPE_SINGLE)
		e4_3:SetCode(EFFECT_IMMUNE_EFFECT)
		e4_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4_3:SetRange(LOCATION_MZONE)
		e4_3:SetValue(c1110151.efilter4_3)
		e4_3:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4_3)
	end
end
function c1110151.efilter4_1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c1110151.efilter4_2(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c1110151.efilter4_3(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--
function c1110151.cfilter5(c)
	return c:IsAbleToGraveAsCost()
end
function c1110151.cost5(e,c,tp)
	return Duel.IsExistingMatchingCard(c1110151.cfilter5,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
end
--
function c1110151.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1110151.cfilter5,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
--
