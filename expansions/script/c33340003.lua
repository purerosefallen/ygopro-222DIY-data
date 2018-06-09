--神之讣告
function c33340003.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(33340003,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCost(c33340003.cost)
	e1:SetTarget(c33340003.target)
	e1:SetOperation(c33340003.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetDescription(aux.Stringid(33340003,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCost(c33340003.cost)
	e2:SetTarget(c33340003.target2)
	e2:SetOperation(c33340003.activate2)
	c:RegisterEffect(e2)
end
function c33340003.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33340003.cfilter2,1,nil,1-tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,1)
end
function c33340003.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c33340003.cfilter2(c,tp)
end
function c33340003.activate2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c33340003.filter2,nil,e,1-tp)
	if sg:GetCount()<=0 then return end
	if sg:GetCount()>1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   sg=sg:Select(tp,1,1,nil)	  
	end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c33340003.aclimit)
	e1:SetLabelObject(sg:GetFirst())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33340003.cfilter2(c,tp)
	return c:IsControler(tp) and c:IsAbleToDeck()
end
function c33340003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c33340003.cfilter(c,tp)
	return not c:IsReason(REASON_DRAW) and c:IsControler(tp) and c:IsAbleToRemove()
end
function c33340003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33340003.cfilter,1,nil,1-tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,1)
end
function c33340003.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c33340003.cfilter(c,tp)
end
function c33340003.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c33340003.filter,nil,e,1-tp)
	if sg:GetCount()<=0 then return end
	if sg:GetCount()>1 then
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	   sg=sg:Select(1-tp,1,1,nil)		
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c33340003.aclimit)
	e1:SetLabelObject(sg:GetFirst())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33340003.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end


