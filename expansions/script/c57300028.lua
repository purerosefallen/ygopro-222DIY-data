--库拉丽丝-樱绽
local m=57300028
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,function(c) return c:IsSetCard(0x570) end,2,3,function(g,lc)
		return g:IsExists(Card.IsType,1,nil,TYPE_XYZ)
	end)
	miyuki.AddSummonMusic(c,aux.Stringid(m,1),SUMMON_TYPE_LINK)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(miyuki.SummonTypeCondition(SUMMON_TYPE_LINK))
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_COST_CHANGE_KOISHI)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.rval)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+0x14000)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(aux.dogcon)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x570) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.counterfilter(c)
	return c:IsSetCard(0x570)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x570)
end
function cm.rval(e,re,tp,ct,r,c)
	if r&REASON_COST~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x570) and e:GetHandler():GetLinkedGroup():IsContains(re:GetHandler()) then return 0 else return ct end
end
function cm.tfilter1(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCode(m-3) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(cm.tfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not cm.target1(e,tp,eg,ep,ev,re,r,rp,0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc then
		sc:SetMaterial(nil)
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end