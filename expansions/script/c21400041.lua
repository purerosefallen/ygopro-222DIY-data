--露文律的隐居者 钟
function c21400041.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--toextra
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21400041,0))
	e0:SetCategory(CATEGORY_TOEXTRA)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1)
	e0:SetTarget(c21400041.tetg)
	e0:SetOperation(c21400041.teop)
	c:RegisterEffect(e0)


	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400041,1))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,21400041)
	e2:SetCost(c21400041.wtfcost)
	e2:SetTarget(c21400041.wtfshtg)
	e2:SetOperation(c21400041.wtfshop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21400041,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c21400041.thtg)
	e4:SetOperation(c21400041.thop)
	c:RegisterEffect(e4)

end

function c21400041.wtfdkfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToHand() and c:IsSetCard(0xc21) and c:IsType(TYPE_MONSTER)
end

function c21400041.wtffilter(c,tp)
	return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c21400041.wtfdkfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end

function c21400041.wtfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400041.wtffilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400041.wtffilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		e:SetLabel(tc:GetAttribute())
	end
	Duel.SendtoGrave(g,REASON_COST)
end

function c21400041.wtfshtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21400041.wtfshop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400041.wtfdkfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



function c21400041.tefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsRace(RACE_WYRM)
end

function c21400041.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(tp) and c21400041.tefilter(chkc) end

	if chk==0 then return Duel.IsExistingTarget(c21400041.tefilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsPlayerCanSpecialSummonMonster(tp,2149999,0xc21,0x4011,0,0,3,RACE_WYRM,ATTRIBUTE_WATER) end
--  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21400041,1))

	local g=Duel.SelectTarget(tp,c21400041.tefilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,99,nil)

	local cnt=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,cnt,0,0)
	local cntfg=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if cntfg>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,cntfg,0,0)
	end
end

function c21400041.atkfl(c)
	return c:GetAttack()>=0
end
function c21400041.deffl(c)
	return c:GetDefense()>=0
end

function c21400041.teop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local cntrn=Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	if cntrn<=0 then return end

	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,2149999,0xc21,0x4011,0,0,3,RACE_WYRM,ATTRIBUTE_WATER) then return end

	local atkn=g:Filter(c21400041.atkfl,nil):GetSum(Card.GetAttack)
	local defn=g:Filter(c21400041.deffl,nil):GetSum(Card.GetDefense)


	local token=Duel.CreateToken(tp,2149999)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atkn)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(defn)
		token:RegisterEffect(e2,true)   
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e4:SetValue(1)
		token:RegisterEffect(e4)   
	end
	Duel.SpecialSummonComplete()

end

function c21400041.thfilter(c)
	return c:IsAbleToGrave()
end
function c21400041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400041.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21400041.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400041.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end


