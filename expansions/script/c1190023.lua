--真红之绊·波拉
--
c1190023.dfc_front_side=1190021
c1190023.dfc_back1_side=1190022
c1190023.dfc_back2_side=1190023
--
function c1190023.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCountLimit(1)
	e0:SetCondition(c1190023.backon)
	e0:SetOperation(c1190023.backop)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1190023,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c1190023.tg1)
	e1:SetOperation(c1190023.op1)
	c:RegisterEffect(e1)
--
end
--
function c1190023.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back2_side
end
function c1190023.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tcode=c.dfc_front_side
	c:SetEntityCode(tcode)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end
--
function c1190023.tfilter1_1(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c1190023.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c1190023.tfilter1_1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1190023.tfilter1_1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local sg=Duel.SelectTarget(tp,c1190023.tfilter1_1,tp,0,LOCATION_MZONE,1,1,nil)
end
--
function c1190023.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if tc:IsFacedown() then return end
	if tc:IsPosition(POS_DEFENSE) then return end
	if not tc:IsRelateToEffect(e) then return end
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1_1:SetValue(-400)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
		local num1=tc:GetDefense()
		local num2=tc:GetTextDefense()
		if num1==num2 then return end
		local dam=0
		if num1>num2 then dam=num1-num2
		else dam=num2-num1 end
		if dam>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
--
