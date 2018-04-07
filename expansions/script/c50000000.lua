--覇王青竜オッドアイズ・ウォール・ドラゴン
function c50000000.initial_effect(c)
	-- link summon
	aux.AddLinkProcedure(c,nil,2,2,function(g,lc) return g:IsExists(Card.IsCode,1,nil,5043010) and g:IsExists(Card.IsCode,1,nil,16178681) end)
	c:EnableReviveLimit()
	-- pendulum summon
	aux.EnablePendulumAttribute(c,false)
	-- special summon graveyard p monsters
	local e_spp=Effect.CreateEffect(c)
	e_spp:SetDescription(aux.Stringid(51808422,0))
	e_spp:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e_spp:SetType(EFFECT_TYPE_IGNITION)
	e_spp:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e_spp:SetRange(LOCATION_PZONE)
	e_spp:SetCountLimit(1,50000000)
	e_spp:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local filter_func=function(c,e,tp) return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
		if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and filter_func(chkc,e,tp) end
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(filter_func,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,filter_func,tp,LOCATION_GRAVE,0,1,5,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	end)
	e_spp:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if sg:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg:Select(tp,ft,ft,nil)
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end)
	c:RegisterEffect(e_spp)
	-- to hand
	local e_th=Effect.CreateEffect(c)
	e_th:SetDescription(aux.Stringid(73964868,0))
	e_th:SetCategory(CATEGORY_TOHAND)
	e_th:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e_th:SetType(EFFECT_TYPE_QUICK_O)
	e_th:SetRange(LOCATION_MZONE)
	e_th:SetCountLimit(1)
	e_th:SetCode(EVENT_FREE_CHAIN)
	e_th:SetHintTiming(0,0x1e0)
	e_th:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		local max_count=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsType(TYPE_PENDULUM),tp,LOCATION_EXTRA,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,max_count,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	end)
	e_th:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end)
	c:RegisterEffect(e_th)
	-- false p summon
	local e_eventlook=Effect.CreateEffect(c)
	e_eventlook:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_eventlook:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e_eventlook:SetRange(LOCATION_MZONE)
	e_eventlook:SetCode(EVENT_LEAVE_FIELD)
	e_eventlook:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(function(c,tp,zone)
			local seq=c:GetPreviousSequence()
			if c:GetPreviousControler()~=tp then seq=seq+16 end
			return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
		end,1,nil,tp,e:GetHandler():GetLinkedZone())
	end)
	e_eventlook:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+50000000,e,0,tp,0,0)
	end)
	c:RegisterEffect(e_eventlook)
	local e_fps=Effect.CreateEffect(c)
	e_fps:SetDescription(aux.Stringid(5043010,1))
	e_fps:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e_fps:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e_fps:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e_fps:SetCode(EVENT_CUSTOM+50000000)
	e_fps:SetRange(LOCATION_MZONE)
	e_fps:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local filter_func=function(c,e,tp,zone) return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
		if chk==0 then
			local zone=e:GetHandler():GetLinkedZone(tp)
			return zone~=0 and Duel.IsExistingMatchingCard(filter_func,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,zone)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	end)
	e_fps:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local zone=e:GetHandler():GetLinkedZone(tp)
		if zone==0 then return end
		local filter_func=function(c,e,tp,zone) return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,filter_func,tp,LOCATION_HAND,0,1,3,nil,e,tp,zone)
		if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone) end
	end)
	c:RegisterEffect(e_fps)
	-- to p zone
	local e_2pz=Effect.CreateEffect(c)
	e_2pz:SetDescription(aux.Stringid(58074177,3))
	e_2pz:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e_2pz:SetCode(EVENT_LEAVE_FIELD)
	e_2pz:SetProperty(EFFECT_FLAG_DELAY)
	e_2pz:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
	end)
	e_2pz:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	end)
	e_2pz:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	end)
	c:RegisterEffect(e_2pz)
end
c50000000.pendulum_level=10