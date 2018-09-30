--赫里奥波里斯之护城龙
function c76121040.initial_effect(c)
	c:EnableReviveLimit()
	--announce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76121040,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,76121040)
	e1:SetTarget(c76121040.tgtg)
	e1:SetOperation(c76121040.tgop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121040,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,76121140)
	e2:SetCondition(c76121040.spcon)
	e2:SetTarget(c76121040.sptg)
	e2:SetOperation(c76121040.spop)
	c:RegisterEffect(e2)
end
function c76121040.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local b2=g:GetCount()>0
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and (b1 or b2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	c76121040.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c76121040.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c76121040.tgop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local b2=dg:GetCount()>0
	if b1 or b2 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()>0 then
			Duel.ConfirmCards(tp,g)
			local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
			local tg=g:Filter(Card.IsCode,nil,ac)
			if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT+REASON_DISCARD)~=0 then
				local op=0
				if b1 and b2 then
					if e:GetLabel()==1 then
						op=Duel.SelectOption(tp,aux.Stringid(76121040,1),aux.Stringid(76121040,2),aux.Stringid(76121040,3))
					else
						op=Duel.SelectOption(tp,aux.Stringid(76121040,1),aux.Stringid(76121040,2))
					end
				elseif b1 then
					op=Duel.SelectOption(tp,aux.Stringid(76121040,1))
				else
					op=Duel.SelectOption(tp,aux.Stringid(76121040,2))+1
				end
				if op~=1 then
					Duel.Draw(tp,2,REASON_EFFECT)
					Duel.ShuffleHand(tp)
					Duel.BreakEffect()
					Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
				end
				if op~=0 then
					local desg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
					if desg:GetCount()>0 then
						Duel.Destroy(desg,REASON_EFFECT)
					end
				end
			end
			Duel.ShuffleHand(1-tp)
		end
	end
end
function c76121040.spfilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c76121040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and not Duel.IsExistingMatchingCard(c76121040.spfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
end
function c76121040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c76121040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end