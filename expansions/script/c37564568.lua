--Nanahira the Perfection
local m=37564568
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,37564765),2,7)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetCode(EFFECT_SPSUMMON_CONDITION)
	ex:SetValue(cm.splimit)
	c:RegisterEffect(ex)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(Senya.SummonTypeCondition(SUMMON_TYPE_LINK))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e88=Effect.CreateEffect(c)
	e88:SetDescription(aux.Stringid(m,1))
	e88:SetCategory(CATEGORY_REMOVE)
	e88:SetType(EFFECT_TYPE_QUICK_O)
	e88:SetCode(EVENT_FREE_CHAIN)
	e88:SetRange(LOCATION_MZONE)
	e88:SetHintTiming(0,0x1e0)
	e88:SetCost(cm.tdcost)
	e88:SetTarget(cm.tgtg)
	e88:SetOperation(cm.tgop)
	c:RegisterEffect(e88)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end
function cm.atkval(e,c)
	return c:GetLinkedGroup():FilterCount(function(c) return c:IsFaceup() and c:IsCode(37564765) end,nil)*2850
end
function cm.splimit(e,se,sp,st)
	return (st & SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function cm.filter(c,e,tp,t)
	local f=(t==TYPE_XYZ) and Card.IsRankBelow or Card.IsLevelBelow
	return c:IsType(t) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and f(c,8)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>2
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,TYPE_FUSION)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,TYPE_XYZ)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not cm.target(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local g={}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g[1]=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,TYPE_FUSION)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g[2]=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,TYPE_SYNCHRO)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g[3]=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,TYPE_XYZ)
	for i=1,3 do
		local tc=g[i]:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local ex=Effect.CreateEffect(e:GetHandler())
		ex:SetType(EFFECT_TYPE_SINGLE)
		ex:SetCode(EFFECT_ADD_CODE)
		ex:SetValue(37564765)
		ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ex:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(ex,true)
	end
	Duel.SpecialSummonComplete()
end
function cm.costfilter(c)
	return c:IsCode(37564765)
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,cm.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end