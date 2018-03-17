--半神之女儿，波恋达斯
function c12008004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12008004.spcon)
	c:RegisterEffect(e1)	
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12008004,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c12008004.postg)
	e2:SetOperation(c12008004.posop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12008004,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetTarget(c12008004.tdtg)
	e3:SetOperation(c12008004.tdop)
	c:RegisterEffect(e3)
end
function c12008004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=Duel.GetAttackTarget()
	if chk ==0 then return Duel.GetAttacker()==e:GetHandler() and t~=nil and not t:IsAttackPos() and t:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,t,1,0,0)
end
function c12008004.tdop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetAttackTarget()
	if t~=nil and t:IsRelateToBattle() and not t:IsAttackPos() then
		Duel.SendtoDeck(t,nil,2,REASON_EFFECT)
	end
end
function c12008004.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c12008004.spfilter,tp,0,LOCATION_MZONE,nil)
	local ct2=1 
	if ct>=3 then ct2=ct end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,ct2,nil) end
	if ct>=3 then
	   e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
	   e:SetProperty(nil)
	end
end
function c12008004.posop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c12008004.spfilter,tp,0,LOCATION_MZONE,nil)
	local ct2=1 
	if ct>=3 then ct2=ct end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<ct2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,ct2,ct2,nil)
	Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
end
function c12008004.spfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c12008004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12008004.spfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end