--樱迷宫之主 BB
function c18713101.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c18713101.mfilter,c18713101.mfilter2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c18713101.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetRange(LOCATION_EXTRA)
	--e2:SetCondition(c18713101.spcon)
	--e2:SetOperation(c18713101.spop)
	--c:RegisterEffect(e2)
	--disable and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(c18713101.disop)
	c:RegisterEffect(e3)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(18713101,0))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(c18713101.condition)
	e5:SetTarget(c18713101.destg)
	e5:SetOperation(c18713101.desop)
	c:RegisterEffect(e5)
	--search
	local e6=e5:Clone()
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_REMOVE)
	e6:SetDescription(aux.Stringid(18713101,1))
	e6:SetTarget(c18713101.thtg)
	e6:SetOperation(c18713101.thop)
	c:RegisterEffect(e6)
end
function c18713101.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c18713101.mfilter(c)
	return c:IsFusionCode(18713100)
end
function c18713101.mfilter2(c)
	return c:IsFusionSetCard(0xab6) and c:GetLevel()==8
end
function c18713101.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c18713101.spfilter1(c,tp,fc)
	return c:IsCode(18713100) and c:IsCanBeFusionMaterial(fc)
		and Duel.CheckReleaseGroup(tp,c18713101.spfilter2,1,c,fc)
end
function c18713101.spfilter2(c,fc)
	return c:IsSetCard(0xab6) and c:GetLevel()==8 and c:IsCanBeFusionMaterial(fc)
end
function c18713101.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c18713101.spfilter1,1,nil,tp,c)
end
function c18713101.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c18713101.spfilter1,1,1,nil,tp,c)
	local g2=Duel.SelectReleaseGroup(tp,c18713101.spfilter2,1,1,g1:GetFirst(),c)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c18713101.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then return end
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c18713101.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c18713101.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g2>0 then
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
function c18713101.filter(c)
	return c:IsSetCard(0xab6) and c:IsAbleToRemove()
end
function c18713101.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18713101.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c18713101.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c18713101.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c18713101.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if ct==2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end