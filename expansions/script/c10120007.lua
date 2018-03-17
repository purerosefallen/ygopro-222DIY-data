--天选圣女 神圣之齐格鲁娜
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
local m=10120007
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	dsrsv.DanceSpiritSummonSucessEffect(c,m,CATEGORY_DESTROY,cm.sstg,cm.ssop,cm.sscon)
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_TOGRAVE,cm.ntg,cm.nop)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c)
	return (not c:IsRace(RACE_FAIRY) or c:IsFacedown()) and c:IsAbleToGrave()
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,LOCATION_MZONE)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),1-tp,LOCATION_SZONE)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep and Duel.GetCurrentChain()==0
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	if Duel.Destroy(eg,REASON_EFFECT)~=0 then
	   Duel.BreakEffect()
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end




