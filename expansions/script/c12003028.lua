--水歌 圆奏龍碧斯安
function c12003028.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_SEASERPENT),3,false) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12003028.splimit)
	c:RegisterEffect(e1)  
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c12003028.spcon)
	e2:SetOperation(c12003028.spop)
	c:RegisterEffect(e2) 
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12003028,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12003028.cost)
	e3:SetOperation(c12003028.operation)
	c:RegisterEffect(e3)
end
function c12003028.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and c12003028.tdfilter(c,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c12003028.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e:GetLabel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12003028.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c12003028.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
	   local g=Duel.GetMatchingGroup(c12003028.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetLabel())
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12003028,4)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		  local tg=g:Select(tp,1,1,nil)
		  Duel.HintSelection(tg)
		  Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	   end
	end
end
function c12003028.tdfilter(c,ctype)
	return c:IsFaceup() and c:IsType(ctype) and c:IsAbleToDeck()
end
function c12003028.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=100 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003028,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c12003028.tdtg)
	e1:SetOperation(c12003028.tdop)
	c:RegisterEffect(e1)
	e1:SetLabel(TYPE_MONSTER)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(12003028,2))
	c:RegisterEffect(e2)
	e2:SetLabel(TYPE_SPELL)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(12003028,3))
	c:RegisterEffect(e3)
	e3:SetLabel(TYPE_TRAP)
end
function c12003028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsRace,1,nil,RACE_SEASERPENT) then
	   e:SetLabel(100)
	end
end
function c12003028.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c12003028.sprfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp,c)
end
function c12003028.sprfilter0(c,fc)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)
end
function c12003028.sprfilter1(c,tp,fc)
	return c12003028.sprfilter0(c,fc) and Duel.IsExistingMatchingCard(c12003028.sprfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,tp,fc,c)
end
function c12003028.sprfilter2(c,tp,fc,mc)
	local g=Group.FromCards(c,mc)
	return c12003028.sprfilter0(c,fc) and Duel.IsExistingMatchingCard(c12003028.sprfilter3,tp,LOCATION_MZONE+LOCATION_HAND,0,1,g,tp,fc,g)
end
function c12003028.sprfilter3(c,tp,fc,g)
	local g2=g:Clone()
	g2:AddCard(c)
	return c12003028.sprfilter0(c,fc) and Duel.GetLocationCountFromEx(tp,tp,g2)>0
end
function c12003028.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c12003028.sprfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c12003028.sprfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1,tp,c,g1:GetFirst())
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c12003028.sprfilter3,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1,tp,c,g1)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c12003028.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA+LOCATION_GRAVE)
end
