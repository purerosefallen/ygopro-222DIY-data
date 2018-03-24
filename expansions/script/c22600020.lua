--音语—青春旋律之大号&小号
function c22600020.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x260),2,2)
	c:EnableReviveLimit()

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22600020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22600020)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c22600020.sptg)
	e1:SetOperation(c22600020.spop)
	c:RegisterEffect(e1)

	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22600020,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22600021)
	e2:SetCondition(c22600020.drcon)
	e2:SetTarget(c22600020.drtg)
	e2:SetOperation(c22600020.drop)
	c:RegisterEffect(e2)
end

function c22600020.cfilter(c)
	return c:IsAbleToDeckAsCost()
end

function c22600020.filter(c,e,tp,lv)
	return c:IsSetCard(0x260) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c22600020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=math.min(6,Duel.GetMatchingGroupCount(c22600020.cfilter,tp,0,LOCATION_REMOVED,nil))
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22600020.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ct)
	end
	local cg=Duel.GetMatchingGroup(c22600020.cfilter,tp,0,LOCATION_REMOVED,nil)
	local ct=math.min(6,cg:GetCount())
	local tg=Duel.GetMatchingGroup(c22600020.filter,tp,LOCATION_DECK,0,nil,e,tp,ct)
	local lvt={}
	local pc=1
	for i=1,6 do
		if tg:IsExists(c22600020.sfilter,1,nil,i,e,tp) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600020,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:Select(tp,lv,lv,nil)
	Duel.SendtoDeck(rg,1-tp,2,REASON_COST)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c22600020.sfilter(c,lv,e,tp)
	return c:IsSetCard(0x260) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c22600020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22600020.sfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c22600020.drfilter(c,p)
	return c:IsFacedown() and c:IsControler(p)
end

function c22600020.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22600020.drfilter,1,nil,1-tp)
end

function c22600020.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c22600020.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
