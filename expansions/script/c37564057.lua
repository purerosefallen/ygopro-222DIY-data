--蔷薇的天选者
local m=37564057
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(m*16)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(m*16+1)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.exfilter(c,rose,mc)
	return c:IsXyzSummonableByRose(rose,mc)
end
function cm.exfilter_chkc(c,rose,mc,lv)
	return c:IsXyzSummonableByRose(rose,mc) and mc:IsXyzLevel(c,lv)
end
function cm.mfilter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.exfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and Duel.IsExistingMatchingCard(cm.exfilter_chkc,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),chkc,e:GetLabelObject():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(cm.mfilter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,cm.mfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabelObject(g:GetFirst())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or c:IsImmuneToEffect(e) then return end
	local exg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_EXTRA,0,nil,c,tc)
	if #exg<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=exg:Select(tp,1,1,nil):GetFirst()
	Duel.XyzSummonByRose(tp,sc,c,tc)
	Duel.ShuffleHand(tp)
end
function cm.filter1(c)
	return c:IsCode(37564017) and c:IsAbleToRemove()
end
function cm.filter2(c)
	return c:IsCode(37564014) and c:IsAbleToRemove()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,37564015,0,0x21,3000,2500,10,RACE_PLANT,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,37564015) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg~=2 or Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=2 then return end
	if Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,37564015,0,0x21,3000,2500,10,RACE_PLANT,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,37564015) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,37564015)
		if #g>0 then
			local tc=g:GetFirst()
			Duel.BreakEffect()
			tc:AddMonsterAttribute(TYPE_EFFECT)
			Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
			tc:AddMonsterAttributeComplete()
			local ne=Senya.NegateEffectModule(tc,1)
			ne:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(ne,true)
			Duel.SpecialSummonComplete()
			Duel.Hint(HINT_MUSIC,0,m*16+2)
		end
	end
end