--S.T. 哀恸之人
function c22270141.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270141,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,222701411)
	e1:SetTarget(c22270141.target)
	e1:SetOperation(c22270141.operation)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22270141,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,222701412)
	e3:SetTarget(c22270141.sptg)
	e3:SetOperation(c22270141.spop)
	c:RegisterEffect(e3)
	if c22270141.counter==nil then
		c22270141.counter=true
		c22270141[0]=0
		c22270141[1]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c22270141.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_DESTROYED)
		e5:SetOperation(c22270141.addcount)
		Duel.RegisterEffect(e5,0)
	end
end
c22270141.named_with_ShouMetsu_ToShi=1
function c22270141.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270141.filter1(c,e,tp,lv,tc)
	local clv=c:GetLevel()
	local g=Group.FromCards(c,tc)
	return clv>0 and not c:IsType(TYPE_TUNER) and c22270141.IsShouMetsuToShi(c) and c:IsDestructable() and Duel.IsExistingMatchingCard(c22270141.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv) and Duel.GetLocationCountFromEx(tp,tp,g)>0 and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c22270141.filter2(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22270141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22270141.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,tc,e,tp,tc:GetLevel(),tc) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,2,0,0)
end
function c22270141.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c22270141.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,tc,e,tp,tc:GetLevel(),tc)
	g:AddCard(tc)
	local lv=g:GetSum(Card.GetLevel)
	if Duel.Destroy(g,REASON_EFFECT)<2 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	local sg=Duel.SelectMatchingCard(tp,c22270141.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22270141.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c22270141[0]=0
	c22270141[1]=0
end
function c22270141.addcount(e,tp,eg,ep,ev,re,r,rp)
	local x=eg:FilterCount(Card.IsRace,nil,RACE_MACHINE)
	c22270141[rp]=c22270141[rp]+x
end
function c22270141.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return c22270141[tp]+c22270141[1-tp]>3 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c22270141.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end