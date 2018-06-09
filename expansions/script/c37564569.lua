--Glitter -Halozy Remix-
local m=37564569
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
cm.Senya_name_with_remix=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.GetFlagEffect(tp,m)==0
	end)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.sfilter(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and Senya.check_set_3L(c) and c:IsLevel(7)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and mc:IsCanBeFusionMaterial(c)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.mfilter(c,e,tp)
	return cm.Senya_desc_with_nanahira and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_EXTRA,0,1,c,e,tp,c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)	
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc)
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummonStep(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			local ex=Effect.CreateEffect(e:GetHandler())
			ex:SetType(EFFECT_TYPE_SINGLE)
			ex:SetCode(EFFECT_ADD_CODE)
			ex:SetValue(37564765)
			ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			ex:SetReset(RESET_EVENT+0xfe0000)
			sc:RegisterEffect(ex,true)
			Duel.SpecialSummonComplete()
			sc:CompleteProcedure()
		end
	end
end