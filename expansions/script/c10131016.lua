--自由斗士-狂兽金雷虎
function c10131016.initial_effect(c)
	--Syn Xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(10131016)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10131016,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c10131016.spcon)
	e2:SetTarget(c10131016.sptg)
	e2:SetOperation(c10131016.spop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)  
	c:RegisterEffect(e4) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10131016,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10131016)
	e3:SetTarget(c10131016.thtg)
	e3:SetOperation(c10131016.thop)
	c:RegisterEffect(e3)
end
function c10131016.cfilter(c,tp)
	return c:IsSetCard(0x5338) and c:IsFaceup() and c:IsControler(tp)
end
function c10131016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10131016.cfilter,1,nil,tp)
end
function c10131016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10131016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10131016.thfilter(c,tp)
	return c:IsSetCard(0x5338) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsAbleToHand()
end
function c10131016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10131016.thfilter,1,e:GetHandler(),tp) and e:GetHandler():IsAbleToHand() end
	local g=eg:Filter(c10131016.thfilter,nil,tp)
	Duel.SetTargetCard(g)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0xff)
end
function c10131016.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsAbleToHand() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local rg=g:Select(tp,1,1,nil)
	if rg:GetCount()>0 then
		rg:AddCard(c)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
	end
end