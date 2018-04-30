--元灵的彼岸·Senya
local m=37564058
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	Senya.AddSummonMusic(c,aux.Stringid(m,2),SUMMON_TYPE_LINK)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,4),2,2)
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
	e2:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.rval(e,re,tp,ct,r,c)
	if r&REASON_COST~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and Senya.check_set_elem(re:GetHandler()) and e:GetHandler():GetLinkedGroup():IsContains(re:GetHandler()) then return 0 else return ct end
end
function cm.filter(c,e,tp)
	return c:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(c)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function cm.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Senya.check_set_elem(c) and tc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0 and Senya.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsAttribute(tc:GetAttribute()) and cm.mcheck(c,tc)
end
function cm.mcheck(c,tc)
	if tc:IsStatus(STATUS_NO_LEVEL) then
		return false
	elseif tc:IsType(TYPE_XYZ) then
		return c:IsRank(tc:GetRank()+1)
	elseif tc:IsType(TYPE_LINK) then
		return c:IsRank(tc:GetLink()*2)
	else
		return c:IsRank(tc:GetLevel())
	end
end
function cm.mcheck_chkc(c,tc)
	if tc:IsStatus(STATUS_NO_LEVEL) then
		return false
	elseif tc:IsType(TYPE_XYZ) then
		return c:IsRank(tc:GetRank())
	elseif tc:IsType(TYPE_LINK) then
		return c:IsLink(tc:GetLink())
	else
		return c:IsLevel(tc:GetLevel())
	end
end
function cm.chkfilter(c,tc,e)
	return c:IsFaceup() and c:GetType()&tc:GetType()==tc:GetType() and cm.mcheck_chkc(c,tc) and Duel.GetLocationCountFromEx(tp,tp,c)>0 and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.chkfilter(chkc,e:GetLabelObject(),e) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabelObject(g:GetFirst())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if #mg~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,tc)
		Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
