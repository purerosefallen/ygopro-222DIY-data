--真実の絶傑・ライオ
local m=17090023
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91588074,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.sumsuc)
	c:RegisterEffect(e2)
end
function cm.IsSpellboostCard(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Spellboos_Card
end
function cm.rfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(cm.mzfilter,ct,nil,tp))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,cm.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,cm.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<1 then return end
		Duel.ConfirmCards(tp,g)
	local g1=g:Filter(cm.IsSpellboostCard,nil)
	local nc=g1:GetFirst()
	while nc do
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc:RegisterFlagEffect(1919510,RESET_EVENT+RESET_LEAVE,0,0)
		nc=g1:GetNext()
	end
end